module Accounts
  class CreateService < ::BaseService
    def process_execute
      account = Account.new(**params)
      if account.save
        { success: true, account: account }
      else
        { success: false, error: account.errors.full_messages.first }
      end
    rescue => e
      { success: false, error: e.message }
    end
  end
end
