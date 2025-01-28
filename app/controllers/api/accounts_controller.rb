class Api::AccountsController < ApplicationController
  def create
    result = ::Accounts::CreateService.new(**account_params).call

    if result[:success]
      render json: result[:account], status: :created
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end

  def show
    result = ::Accounts::FindService.new(id: params[:id]).call

    if result[:success]
      render json: result[:account], status: :ok
    else
      render json: { error: result[:error] }, status: :not_found
    end
  end

  def update
    result = ::Accounts::UpdateService.new(id: params[:id], **account_params).call

    if result[:success]
      render json: result[:account], status: :ok
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end

  def destroy
    result = ::Accounts::DeleteService.new(id: params[:id]).call

    if result[:success]
      render json: { message: result[:message] }, status: :ok
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end

  def deposit
    result = ::Transactions::DepositService.new(id: deposit_params[:id], amount: deposit_params[:amount].to_d).call

    if result[:error]
      render json: { error: result[:error] }, status: :unprocessable_entity
    else
      render json: result, status: :ok
    end
  end

  def withdraw
    result = ::Transactions::WithdrawService.new(id: withdraw_params[:id], amount: withdraw_params[:amount].to_d).call

    if result[:error]
      render json: { error: result[:error] }, status: :unprocessable_entity
    else
      render json: result, status: :ok
    end
  end

  def transfer
    result = ::Transactions::TransferService.new(id: transfer_params[:id], to_account_id: transfer_params[:to_account_id], amount: transfer_params[:amount].to_d).call

    if result[:error]
      render json: { error: result[:error] }, status: :unprocessable_entity
    else
      render json: result, status: :ok
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  private

  def account_params
    params.require(:account).permit(:name, :balance)
  end

  def deposit_params
    params.permit(:id, :amount)
  end

  def withdraw_params
    params.permit(:id, :amount)
  end

  def transfer_params
    params.permit(:id, :to_account_id, :amount)
  end

  def validate_transfer_params
    unless params[:id] && params[:to_account_id] && params[:amount]
      render json: { error: 'Invalid transfer parameters' }, status: :bad_request
    end
  end
end
