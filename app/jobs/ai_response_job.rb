class AiResponseJob < ApplicationJob
  queue_as :default

  def perform(chat_message_id)
    chat_message = ChatMessage.find(chat_message_id)
    chat_message.body
    client = Ollama.new(
      credentials: { address: 'http://localhost:11434' },
      options: { server_sent_events: true }
    )
    training_data = Training.all.pluck(:body).join
    prompt = "Here is some info about me: #{training_data}. Can you answer my question: #{chat_message.body}"
    result = client.generate(
      { model: 'llama2',
        prompt: prompt }
    )
    text = result.map { |r| r["response"] }.join
    chat_message.update(ai_response: text)
    chat_message.broadcast_prepend_to(:ai_messages, target: "ai-messages", partial: "chat_messages/ai_response", locals: { text: text })
  end
end
