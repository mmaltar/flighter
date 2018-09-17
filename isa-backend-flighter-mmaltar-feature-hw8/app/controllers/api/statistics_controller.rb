module Api
  class StatisticsController < ApplicationController
    def flights_index
      render json: FlightsQuery.new.with_stats,
             each_serializer: Statistics::FlightsSerializer
    end

    def companies_index
      render json: CompaniesQuery.new.with_stats, each_serializer:
        Statistics::CompaniesSerializer
    end
  end
end
