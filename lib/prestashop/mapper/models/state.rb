using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class State < Model
      resource :states
      model :state

      class << self
        def find_by_iso_code iso_code
          find_by 'filter[iso_code]' => iso_code
        end
      end      
    end
  end
end