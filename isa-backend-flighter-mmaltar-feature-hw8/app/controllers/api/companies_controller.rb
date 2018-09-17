module Api
  class CompaniesController < ApplicationController
    def index
      if params[:filter] == 'active'
        render json: Company.active.order(:name)
      else
        render json: Company.all.order(:name)
      end
    end

    def show
      render json: company
    end

    def create
      company = Company.new(company_params)

      if company.save
        render json: company, status: :created
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    def update
      if company.update(company_params)
        render json: company, status: :ok
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    def destroy
      company.destroy
      head :no_content
    end

    private

    def company
      @company ||= Company.find(params[:id])
    end

    def company_params
      params.require(:company).permit(:name)
    end
  end
end
