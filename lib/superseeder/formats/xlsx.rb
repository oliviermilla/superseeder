module Superseeder
  module Formats
    module Xlsx

      def self.extensions
        %w(.xlsx)
      end

      def __process(path, *args)
        require 'roo'
        xls = Roo::Spreadsheet.open path
        xls = xls.sheet(0)
        header = xls[xls.first_row]
        for idx in (xls.first_row + 1..xls.last_row)
          row = xls.row idx
        end
        sheet = RubyXL::Parser.parse(path).worksheets[0]
        row_index = 0
        header = sheet.sheet_data[row_index].cells.inject(Hash.new){ |stamp, cell| stamp[cell.column] = cell.value and stamp }
        while true do
          row_index += 1 #Skip header line
          row = sheet.sheet_data[row_index]
          break if row.nil?
          row = row.cells.inject(Hash.new) do |stamp, cell|
            stamp[header[cell.column]] = cell.value unless cell.nil?
            stamp
          end
          yield row
          i+= 1
        end
      end

    end
  end
end