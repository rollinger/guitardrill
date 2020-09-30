
class Array

	def ring_access( distance, start_index=0, cycles=0 )
        """
        Access an Array as if it were a cyclic Ring.
        Positive and negative indexes return the value
        as if the array would be infinite in both directions.
        returns the element and the cycles
        """
		if distance > self.size-1
			ring_access( distance - self.size, start_index )
		elsif distance < -(self.size-1)
			ring_access( distance + self.size, start_index)
		else
			return self.rotate( start_index )[ distance ]
		end
	end

    def ring_distance(element1,element2)
        """
        Returns the index of element2 when element1 is set to 0 index of the ring.
        """
        return self.rotate( self.index(element1) ).index(element2)
    end

    def random_element()
        return self[rand(length)]
    end

    def draw(n=1)
        return self.shuffle[0..n-1]
    end

    def to_ring
        return Ring.new(self)
    end

end



class Ring < Array

    def initialize(*args)
        super(*args)
    end

    def distance(element1,element2)
        """
        Returns the index of element2 when element1 is set to 0 index of the ring. Returns nil if one of the elements does not exists.
        """
        return self.rotate( self.index( element1 ) ).index( element2 )
    end

    def cycles(distance)
        return (distance / (self.size.to_f) ).truncate
    end
end
