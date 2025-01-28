module Accounts
  class FindService < ::BaseService
    def process_execute
      account = Account.find_by(id: params[:id])
      if account
        { success: true, account: account }
      else
        { success: false, error: 'Account not found' }
      end
    rescue => e
      { success: false, error: e.message }
    end
  end
end
