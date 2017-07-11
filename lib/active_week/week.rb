module ActiveWeek
  class Week
    include Comparable

    attr_reader :first_day

    WEEKDAY_MONDAY = 1
    WEEKDAY_SUNDAY = 7

    private_constant :WEEKDAY_MONDAY, :WEEKDAY_SUNDAY

    class << self
      def current
        date = Time.zone ? Time.zone.today : Date.today
        new(date.cwyear, date.cweek)
      end
    end

    def initialize(year, number)
      @first_day = Date.commercial(year, number, WEEKDAY_MONDAY)
    end

    def year
      @first_day.cwyear
    end

    def number
      @first_day.cweek
    end

    def last_day
      Date.commercial(year, number, WEEKDAY_SUNDAY)
    end

    def next_week
      date = first_day.next_week
      self.class.new(date.cwyear, date.cweek)
    end

    alias succ next_week

    def prev_week
      date = first_day.prev_week
      self.class.new(date.cwyear, date.cweek)
    end

    def each_day
      return to_enum(__callee__) unless block_given?
      (first_day..last_day).each { |d| yield d }
      self
    end

    def <=>(other)
      raise ArgumentError.new("#{self.class} can't be compared with #{other.class}") unless other.is_a?(self.class)

      first_day <=> other.first_day
    end

    def ==(other)
      raise ArgumentError.new("#{self.class} can't be compared with #{other.class}") unless other.is_a?(self.class)

      first_day == other.first_day
    end

    alias eql? ==

    def hash
      year.hash ^ number.hash
    end
  end
end
