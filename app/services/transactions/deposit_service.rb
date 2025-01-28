module Transactions
  class DepositService < ::BaseService
    def call
      raise ArgumentError, 'Amount must be greater than 0' if params[:amount] <= 0

      account = Account.find_by(id: params[:id])
      account.balance += params[:amount]
      account.save!
      { message: 'Deposit successful', balance: account.balance }
    rescue => e
      { error: e.message }
    end
  end
end
