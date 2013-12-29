module GitDiff
  class DiffFile
    attr_reader :a_path, :a_blob, :b_path, :b_blob, :b_mode, :hunks

    def self.from_string(string)
      if /^diff --git/.match(string)
        DiffFile.new
      end
    end

    def initialize
      @hunks = []
    end

    def <<(string)
      return if extract_diff_meta_data(string)

      if(hunk = Hunk.from_string(string))
        add_hunk hunk
      else
        append_to_current_hunk string
      end
    end

    def total_number_of_lines
      hunks.inject(0) { |count, hunk| count + hunk.count }
    end

    def total_additions
      additions.count
    end

    def total_deletions
      deletions.count
    end

    private

    attr_accessor :current_hunk

    def add_hunk(hunk)
      self.current_hunk = hunk
      hunks << current_hunk
    end

    def append_to_current_hunk(string)
      current_hunk << string
    end

    def additions
      hunks.map { |hunk| hunk.additions }.flatten
    end

    def deletions
      hunks.map { |hunk| hunk.deletions }.flatten
    end

    def extract_diff_meta_data(string)
      case
      when a_path_info = /^[-]{3} a\/(.*)$/.match(string)
        @a_path = a_path_info[1]
      when b_path_info = /^[+]{3} b\/(.*)$/.match(string)
        @b_path = b_path_info[1]
      when blob_info = /^index ([0-9A-Fa-f]+)\.\.([0-9A-Fa-f]+) ?(.+)?$/.match(string)
        @a_blob, @b_blob, @b_mode = *blob_info.captures
      end
    end
  end
end
