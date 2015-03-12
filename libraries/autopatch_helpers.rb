module AutoPatchHelper
  def self.getLCaseWeekdayFromAbbreviation( abbreviatedWeekday )
    case abbreviatedWeekday 
    when "MON", "mon"
      return "monday"
    when "TUE", "tue"
      return "tuesday"
    when "WED", "wed"
      return "wednesday"
    when "THU", "thu"
      return "thursday"
    when "FRI", "fri"
      return "friday"
    when "SAT", "sat"
      return "saturday"
    when "SUN", "sun"
      return "sunday"
    else
      raise "Could not determine weekday from abbreviation '#{abbreviatedWeekday}'"
    end 
  end
end
