class RemoveStatusFromPayments < ActiveRecord::Migration[6.1]
  def change
    remove_column :payments, :status
  end
end
