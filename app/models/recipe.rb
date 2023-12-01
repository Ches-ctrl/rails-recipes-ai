class Recipe < ApplicationRecord
  after_save :set_content, if: -> { saved_change_to_name? || saved_change_to_ingredients? }

  def content
    if super.blank?
      set_content
    else
      super
    end
  end

  def set_content
    Rails.cache.fetch("#{cache_key_with_version}/content") do
      client = OpenAI::Client.new
      chaptgpt_response = client.chat(parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: "Give me a simple recipe for #{name} with the ingredients #{ingredients}. Give me only the text of the recipe, without any of your own answer like 'Here is a simple recipe'."}]
      })
      new_content = chaptgpt_response["choices"][0]["message"]["content"]

      self.update(content: new_content)
      return new_content
    end
  end
end

# Doesn't require self as will do this automatically but included for clarity
