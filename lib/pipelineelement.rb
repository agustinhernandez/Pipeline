class PipelineElement
  attr_accessor :source, :task, :fiber

  def initialize(task, s = nil)
    @source = s
    @task = task
    if @source 
      @fiber = Fiber.new do
        while value = @source.resume
          #do something with value
          # 'nil' will end the process
          @task.call(value)
        end
      end
    else    # first element in the pipeline
      @fiber = Fiber.new do
        @task.call
      end
    end # if
  end

  def |(nextproc)
    nextproc.source = self
    nextproc
  end

  def resume 
    @fiber.resume
  end

end
