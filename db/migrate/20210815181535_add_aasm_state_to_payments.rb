class AddAasmStateToPayments < ActiveRecord::Migration[6.1]
  def change
    add_column :payments, :aasm_state, :string
  end
end
