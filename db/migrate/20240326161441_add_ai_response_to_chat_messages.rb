class AddAiResponseToChatMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :chat_messages, :ai_response, :string
  end
end
