require 'active_record/precounter/version'
require 'active_support/concern'

module ActiveRecord
  class AssociationsCounter
    extend ActiveSupport::Concern
    class MissingInverseOf < StandardError; end

    included do
      class_attribute :association_count_queries, default: {}

      def self.has_many_count(name, scope: nil)
        attr_writer :"#{name}_count"
        reflection = reflections.fetch(name.to_s)

        association_count_queries[name] = lambda do |relation|
          if reflection.inverse_of.nil?
            raise MissingInverseOf, "`#{reflection.klass}` does not have inverse of `#{relation.klass}##{reflection.name}`. "\
              "Probably missing to call `#{reflection.klass}.belongs_to #{relation.name.underscore.to_sym.inspect}`?"
          end

          query = if scope
                    reflection.klass.instance_exec(&scope)
                  else
                    reflection.klass
                  end
          query.where(reflection.inverse_of.name => relation).group(reflection.inverse_of.foreign_key).count
        end

        define_method("#{name}_count") do
          value = instance_variable_get(:"@#{name}_count")
          return value if value
          instance_variable_set(:"@#{name}_count", send(name).instance_exec(&scope).count)
        end
      end

      def self.decorate_count
        records = relation.to_a
        return [] if records.empty?

        queries = relation.model.pre_count_queries.map do |name, query|
          [name, query.call(relation)]
        end.to

        records.each do |record|
          queries.each do |name, counts|
            record.public_send("#{name}_count", counts.fetch(record.id, 0))
          end
        end

        records
      end
    end
  end
end
