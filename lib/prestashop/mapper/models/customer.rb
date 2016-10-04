using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Customer < Model
      resource :customers
      model :customer

      attr_accessor       :firstname, :lastname, :email, :newsletter, :optin, :active, :passwd
      attr_writer         :id

      def initialize args = {}
        @id         = args[:id]
        @firstname  = args.fetch(:firstname)
        @lastname   = args.fetch(:lastname)
        @email      = args.fetch(:email)
        @passwd     = args[:passwd]
        @newsletter = args.fetch(:newsletter, 0)
        @optin      = args.fetch(:optin, 1)
        @active     = args.fetch(:active, 1)
      end

      def id
        @id ||= self.class.find_by 'filter[email]' => email
      end
      alias :find? :id

      def hash
        customer = {
          firstname:  firstname,
          lastname:   lastname,
          email:      email,
          passwd:     passwd,
          newsletter: newsletter,
          optin:      optin,
          active:     active
        }
      end
    end
  end
end