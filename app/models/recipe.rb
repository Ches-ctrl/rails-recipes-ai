class Recipe < ApplicationRecord
  def content
    Rails.cache.fetch("#{cache_key_with_version}/content") do
      client = OpenAI::Client.new
      chaptgpt_response = client.chat(parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: "Give me a simple recipe for #{name} with the ingredients #{ingredients}. Give me only the text of the recipe, without any of your own answer like 'Here is a simple recipe'."}]
      })
      chaptgpt_response["choices"][0]["message"]["content"]
    end
  end
end

# Doesn't require self as will do this automatically but included for clarity
