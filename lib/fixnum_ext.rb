class Fixnum
    def clamp(min,max)
        if min > max
            raise  "min argument must be smaller than max argument"
        end
        c = self <=> min
        if c == 0 then return self.to_i end
        if c < 0 then return min end
        c = self <=> max
        if c > 0 then return max end
    end
end
