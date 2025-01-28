module Transactions
  class WithdrawService < ::BaseService
    def call
      raise ArgumentError, 'Amount must be greater than 0' if params[:amount] <= 0

      account = Account.find_by(id: params[:id])
      raise ArgumentError, 'Insufficient balance' if account.balance < params[:amount]

      account.balance -= params[:amount]
      account.save!
      { message: 'Withdrawal successful', balance: account.balance }
    rescue => e
      { error: e.message }
    end
  end
end
