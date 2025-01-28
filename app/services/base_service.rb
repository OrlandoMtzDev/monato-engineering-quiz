class BaseService
  attr_reader :params

  def initialize(**params)
    @params = params
  end

  def call
    @start_time = Time.now.to_f
    result = process_execute
    log(params:, result:)

    result
  rescue => error
    log(params:, error: error.inspect)
    raise error
  end

  def process_execute
    raise NotImplementedError
  end

  private

  def log(params:, result: nil, error: nil)
    time = (Time.now.to_f - @start_time) * 1_000
    result = "Large set of data (#{result.class})" if result.is_a?(ActiveRecord::Relation)

    Rails.logger.tagged(self.class.name) do
      Rails.logger.info({ params:, result:, error:, run_time: "#{time.to_i} ms" }.to_s)
    end
  end
end
