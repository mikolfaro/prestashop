using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Customer < Model
      resource :customers
      model :customer

      attr_accessor       :firstname, :lastname, :email, :newsletter, :optin, :active, :passwd, :id_default_group, :groups
      attr_writer         :id

      def initialize args = {}
        @id               = args[:id]
        @firstname        = args.fetch(:firstname)
        @lastname         = args.fetch(:lastname)
        @email            = args.fetch(:email)
        @passwd           = args[:passwd]
        @id_default_group = args.fetch(:id_default_group, 3)
        @newsletter       = args.fetch(:newsletter, 0)
        @optin            = args.fetch(:optin, 0)
        @active           = args.fetch(:active, 1)
        @groups           = args[:groups]
      end

      def hash
        customer = {
          firstname:        firstname,
          lastname:         lastname,
          email:            email,
          passwd:           passwd,
          id_default_group: id_default_group,
          newsletter:       newsletter,
          optin:            optin,
          active:           active,
          associations:     {}
        }
        if customer_groups_hash
          customer[:associations][:groups] = {}
          customer[:associations][:groups][:group] = customer_groups_hash
        end
        customer
      end

      def group_row_hash id_group
        { id: id_group } unless id_group.blank?
      end

      def customer_groups_hash
        groups.map { |row| 
          group_row_hash(row[:id])
        } if groups
      end

      def id
        @id ||= self.class.find_by 'filter[email]' => email
      end
      alias :find? :id

      def update options = {}
        self.class.update(id, options) if find?
      end
    end
  end
end