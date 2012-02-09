require 'geo_ruby/simple_features/multi_polygon'

module GeoRuby

  module SqlMM

    #Represents a group of polygons (see Polygon) and curve polygons (see CurvePolygon).
    class MultiSurface < SimpleFeatures::MultiPolygon

      def initialize(srid = DEFAULT_SRID,with_z=false,with_m=false)
        super(srid)
      end

      #TODO
      def binary_geometry_type #:nodoc:
        6
      end

      #WKT geometry type
      def text_geometry_type #:nodoc:
        "MULTISURFACE"
      end

      # simple geojson representation
      # TODO add CRS / SRID support?
      #TODO
      def to_json(options = {})
        {:type => 'MultiPolygon',
         :coordinates => self.to_coordinates}.to_json(options)
      end
      alias :as_geojson :to_json

      #Creates a multi polygon from an array of polygons and curve polygons
      def self.from_polygons(polygons,srid=DEFAULT_SRID,with_z=false,with_m=false)
        multi_surface = new(srid,with_z,with_m)
        multi_surface.concat(polygons)
        multi_surface
      end

    end

  end

end
