class ChangeCompletedDefaultInTodos < ActiveRecord::Migration[8.1]
  def change
    change_column_default :todos, :completed, from: nil, to: false
    change_column_null :todos, :completed, false, false
  end
end
