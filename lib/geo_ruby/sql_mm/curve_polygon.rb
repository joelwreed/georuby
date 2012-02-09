require 'geo_ruby/simple_features/polygon'

module GeoRuby

  module SqlMM

    # Represents a polygon as an array of circular strings (see CircularString), linear strings (see LinearRing), or compound curves (see CompoundCurve).
    # No check is performed regarding the validity of the geometries forming the polygon.
    class CurvePolygon < SimpleFeatures::Polygon
      def initialize(srid = DEFAULT_SRID,with_z=false,with_m=false)
        super(srid,with_z,with_m)
      end

      #binary representation of a polygon, without the headers neccessary for a valid WKB string
      #TODO
      def binary_representation(allow_z=true,allow_m=true)
        rep = [length].pack("V")
        each {|linear_ring| rep << linear_ring.binary_representation(allow_z,allow_m)}
        rep
      end

      #WKB geometry type
      #TODO
      def binary_geometry_type
        3
      end

      #Text representation of a polygon
      def text_representation(allow_z=true,allow_m=true)
        @rings.collect do |line_string|
          if line_string.class.name =~ /^GeoRuby::SqlMM/
            line_string.as_ewkt(false, allow_z, allow_m)
          else
            "(" + line_string.text_representation(allow_z,allow_m) + ")"
          end
        end.join(",")
      end

      #WKT geometry type
      def text_geometry_type
        "CURVEPOLYGON"
      end

      #georss simple representation : outputs only the outer ring
      #TODO
      def georss_simple_representation(options)
        georss_ns = options[:georss_ns] || "georss"
        geom_attr = options[:geom_attr]
        "<#{georss_ns}:polygon#{geom_attr}>" + self[0].georss_poslist + "</#{georss_ns}:polygon>\n"
      end

      #georss w3c representation : outputs the first point of the outer ring
      #TODO
      def georss_w3cgeo_representation(options)
        w3cgeo_ns = options[:w3cgeo_ns] || "geo"

        "<#{w3cgeo_ns}:lat>#{self[0][0].y}</#{w3cgeo_ns}:lat>\n<#{w3cgeo_ns}:long>#{self[0][0].x}</#{w3cgeo_ns}:long>\n"
      end
      #georss gml representation
      #TODO
      def georss_gml_representation(options)
        georss_ns = options[:georss_ns] || "georss"
        gml_ns = options[:gml_ns] || "gml"

        result = "<#{georss_ns}:where>\n<#{gml_ns}:Polygon>\n<#{gml_ns}:exterior>\n<#{gml_ns}:LinearRing>\n<#{gml_ns}:posList>\n" + self[0].georss_poslist + "\n</#{gml_ns}:posList>\n</#{gml_ns}:LinearRing>\n</#{gml_ns}:exterior>\n</#{gml_ns}:Polygon>\n</#{georss_ns}:where>\n"
      end

      #outputs the geometry in kml format : options are <tt>:id</tt>, <tt>:tesselate</tt>, <tt>:extrude</tt>,
      #<tt>:altitude_mode</tt>. If the altitude_mode option is not present, the Z (if present) will not be output (since
      #it won't be used by GE anyway: clampToGround is the default)
      #TODO
      def kml_representation(options = {})
        result = "<Polygon#{options[:id_attr]}>\n"
        result += options[:geom_data] if options[:geom_data]
        rings.each_with_index do |ring, i|
          if i == 0
            boundary = "outerBoundaryIs"
          else
            boundary = "innerBoundaryIs"
          end
          result += "<#{boundary}><LinearRing><coordinates>\n"
          result += ring.kml_poslist(options)
          result += "\n</coordinates></LinearRing></#{boundary}>\n"
        end
        result += "</Polygon>\n"
      end

      # simple geojson representation
      # TODO add CRS / SRID support?
      #TODO
      def to_json(options = {})
        {:type => 'Polygon',
         :coordinates => self.to_coordinates}.to_json(options)
      end
      alias :as_geojson :to_json

      #creates a new polygon. Accepts an array of circular strings, linear strings, or compound curves as argument
      def self.from_linear_rings(rings,srid = DEFAULT_SRID,with_z=false,with_m=false)
        polygon = new(srid,with_z,with_m)
        polygon.concat(rings)
        polygon
      end

    end

  end

end
