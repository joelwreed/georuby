require 'geo_ruby/simple_features/multi_line_string'

module GeoRuby

  module SqlMM

    #Represents a group of circular strings (see CircularString), line strings (see LineString), and compound curves (see CompoundCurve).
    class MultiCurve < SimpleFeatures::MultiLineString

      def initialize(srid = DEFAULT_SRID,with_z=false,with_m=false)
        super(srid)
      end

      #TODO
      def binary_geometry_type #:nodoc:
        5
      end

      #WKT geometry type
      def text_geometry_type #:nodoc:
        "MULTICURVE"
      end

      # simple geojson representation
      # TODO add CRS / SRID support?
      #TODO
      def to_json(options = {})
        {:type => 'MultiLineString',
         :coordinates => self.to_coordinates}.to_json(options)
      end
      alias :as_geojson :to_json
      
      #Creates a new multi line string from an array of circular strings, line strings, and compound curves
      def self.from_line_strings(strings,srid=DEFAULT_SRID,with_z=false,with_m=false)
        multi = new(srid,with_z,with_m)
        multi.concat(strings)
        multi
      end
    end
  end
end
