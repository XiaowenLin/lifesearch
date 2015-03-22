class Sprint < ActiveRecord::Base
  belongs_to :user
  # make all attr accessible
  attr_protected
  # validate entries
  validates :name, :presence => true
  def repeat_weekly
    parent_id = self.parent
    parent_sprint = Sprint.find(parent_id)
    dates = (self.start..parent_sprint.end).select { |t|
      (t - self.start)%7 == 0
    }
    my_sprints = dates.collect { |t|
      Sprint.new(start: t, end: t, name: self.name, desc: self.desc, hours: self.hours, parent: self.parent)
    }
    return my_sprints
  end
  def repeat_tr_weekly
    diff = 0
    if self.start.wday == 2
      diff = 2
    elsif self.start.wday == 4
      diff = -2
    else
      return nil
    end
    other_sprint = self.copy
    other_sprint.start += diff
    other_sprint.end += diff
    other_sprint.repeat_weekly + self.repeat_weekly
  end
  def repeat_mwf_weekly
    diff0 = 0
    diff1 = 0
    if self.start.wday == 1
      diff0 = 2
      diff1 = 4
    elsif self.start.wday == 3
      diff0 = -2
      diff1 = 2
    elsif self.start.wday == 5
      diff0 = -4
      diff1 = -2
    else
      return nil
    end
    sprint0 = self.copy
    sprint0.start += diff0
    sprint0.end += diff0
    sprint1 = self.copy
    sprint1.start += diff1
    sprint1.end += diff1
    sprint0.repeat_weekly + sprint1.repeat_weekly + self.repeat_weekly
  end
  def copy
    res = Sprint.new(name: self.name, parent: self.parent, start: self.start, end: self.end, 
        hours: self.hours, happy: self.happy, desc: self.desc)
  end
end
