require "pipelineelement"

describe PipelineElement, "pipe lines" do

  before(:each) do
    @evens = PipelineElement.new(
              lambda do
                value = 0
                loop do
                  Fiber.yield value
                  value += 2
                end
              end,
            )
               
    @mult = []
    [3, 5].each_with_index  do |k, i| 
      @mult[i] = PipelineElement.new(
        lambda do |value|
           Fiber.yield value if value % k == 0
        end,
        @evens
      )
    end
  end
                 
  it "'pairs | mult5' produce multiples of 5" do
      expected = [ 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, ]

      10.times do |i|
         @mult[1].resume.should == expected[i]
      end
  end

  it "'pairs | mult3| mult5' produce multiples of 30" do
    expected = [ 0, 30, 60, 90, 120, 150, 180, 210, 240, 270, ]
    10.times do |i| 
       (@evens | @mult[0] | @mult[1]).resume.should == expected[i]
    end
  end

end
