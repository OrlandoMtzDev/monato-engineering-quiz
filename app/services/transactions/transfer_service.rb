module Transactions
  class TransferService < ::BaseService
    def call
      raise ArgumentError, 'Amount must be greater than 0' if params[:amount] <= 0

      from_account = Account.find(params[:id])
      raise ArgumentError, 'Insufficient balance in source account' if from_account.balance < params[:amount]

      to_account = Account.find(params[:to_account_id])
      ActiveRecord::Base.transaction do
        from_account.balance -= params[:amount]
        to_account.balance += params[:amount]
        from_account.save!
        to_account.save!
      end

      { message: 'Transfer successful', from_balance: from_account.balance, to_balance: to_account.balance }
    rescue => e
      { error: e.message }
    end
  end
end
