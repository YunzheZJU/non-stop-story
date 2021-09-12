# frozen_string_literal: true

class Transform
  class << self
    def allocate(workers, channels)
      array = workers.map.with_index do |worker, index|
        [
          [worker, index],
          channels.values_at(*index.step(channels.size - 1, workers.size).to_a)
        ]
      end
      array.reject! { |_w, c| c.empty? }
      array.to_h
    end

    def integer!(param)
      param.to_i
    end

    def datetime!(param)
      Time.parse param
    end

    def record!(param, model)
      model.find param
    end

    def solve_mask(mask)
      return nil unless mask

      mask.chars.each_with_index.map { |char, index| char == '1' ? index + 1 : nil }.compact
    end
  end
end
