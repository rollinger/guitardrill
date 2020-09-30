def countdown(interval, text="", silent=true)
    t = Time.new(0)
    countdown_time_in_seconds = interval # change this value
    countdown_time_in_seconds.downto(0) do |seconds|
      time = text + (t + seconds).strftime('%S') + "\r"
      unless silent
        print time
        $stdout.flush
      end
      sleep 1
    end
end



def get_user_input_from_console(allowed_inputs=nil, ignore_case=true, recurse=false, countdown=nil, pre=nil, post=nil)

    
    user_input = gets.chomp()

    # Case Handling if ignore_case=true
    if ignore_case and !allowed_inputs.nil?
      user_input.downcase!
      allowed_inputs.map!{ | allowed_input | allowed_input.to_s.downcase }
    end



    # RETURN VALUE
    return user_input
end



result = get_user_input_from_console(allowed_inputs=[1,2,3,'A'])
