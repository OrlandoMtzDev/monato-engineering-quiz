module Accounts
  class UpdateService < ::BaseService
    def call
      account = Account.find_by(id: params[:id])
      if account.update(**params)
        { success: true, account: account }
      else
        { success: false, error: account.errors.full_messages }
      end
    rescue => e
      { success: false, error: e.message }
    end
  end
end
