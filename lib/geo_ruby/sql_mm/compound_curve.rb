require 'geo_ruby/simple_features/multi_line_string'

module GeoRuby

  module SqlMM

    #Represents a group of circular strings (see CircularString) and line strings (see LineString) that are "continuous".
    #No check is actually made to ensure that the start point of a circular string or line string is equal to the end point of the previous string.
    class CompoundCurve < SimpleFeatures::MultiLineString

      def initialize(srid = DEFAULT_SRID,with_z=false,with_m=false)
        super(srid)
      end

      def binary_geometry_type #:nodoc:
        9
      end

      #Text representation of a multi line string
      def text_representation(allow_z=true,allow_m=true) #:nodoc:
        @geometries.collect do |line_string|
          if line_string.class.name =~ /^GeoRuby::SqlMM/
            line_string.as_ewkt(false, allow_z, allow_m)
          else
            "(" + line_string.text_representation(allow_z,allow_m) + ")"
          end
        end.join(",")
      end

      #WKT geometry type
      def text_geometry_type #:nodoc:
        "COMPOUNDCURVE"
      end

      # simple geojson representation
      # TODO add CRS / SRID support?
      #TODO
      def to_json(options = {})
        {:type => 'MultiLineString',
         :coordinates => self.to_coordinates}.to_json(options)
      end
      alias :as_geojson :to_json
      
      #Creates a new multi line string from an array of circular strings and line strings
      def self.from_line_strings(strings,srid=DEFAULT_SRID,with_z=false,with_m=false)
        multi = new(srid,with_z,with_m)
        multi.concat(strings)
        multi
      end
    end
  end
end
