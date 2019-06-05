require_relative "../estimates/solar"
require_relative "../estimates/pvwatts"

module Plans
  class SolarBase < ::Plans::Base
    def self.solar_eligible
      true
    end

    def initialize(logger, demand_schedule, options)
      @pvwatts = PvwattsEstimate.new options[:pvwatts], options[:offset] if options[:pvwatts]
      super
    end

    def cost_per_watt_installed
      @options[:cpw]
    end

    def system_size
      @options.fetch(:offset, 0).to_f
    end

    def system_cost
      format "$%2.0f", cost_per_watt_installed * system_size * 1000.0
    end

    def offset(date, time, kwh)
      if @pvwatts
        kwh - @pvwatts.estimate(date, time)
      else
        kwh - SolarEstimate.estimate(date, time, @options.fetch(:offset, 0).to_f, @options[:efficiency], @options[:lat], @options[:long])
      end
    end
  end
end
