module Accounts
  class DeleteService < ::BaseService
    def call
      account = Account.find_by(id: params[:id])
      if account.destroy
        { success: true, message: "Account successfully deleted" }
      else
        { success: false, error: account.errors.full_messages }
      end
    rescue => e
      { success: false, error: e.message }
    end
  end
end
