require "geo_ruby/simple_features/line_string"

module GeoRuby
  module SqlMM
    #Represents a circular string as an array of points (see Point).
    class CircularString < SimpleFeatures::LineString
      def initialize(srid= DEFAULT_SRID,with_z=false,with_m=false)
        super(srid,with_z,with_m)
      end

      #WKB geometry type
      def binary_geometry_type #:nodoc:
        8
      end

      #WKT geometry type
      def text_geometry_type #:nodoc:
        "CIRCULARSTRING"
      end

      #georss simple representation
      #TODO
      def georss_simple_representation(options) #:nodoc:
        georss_ns = options[:georss_ns] || "georss"
        geom_attr = options[:geom_attr]
        "<#{georss_ns}:line#{geom_attr}>" + georss_poslist + "</#{georss_ns}:line>\n"
      end
      #georss w3c representation : outputs the first point of the line
      #TODO
      def georss_w3cgeo_representation(options) #:nodoc:
        w3cgeo_ns = options[:w3cgeo_ns] || "geo"
        "<#{w3cgeo_ns}:lat>#{self[0].y}</#{w3cgeo_ns}:lat>\n<#{w3cgeo_ns}:long>#{self[0].x}</#{w3cgeo_ns}:long>\n"
      end
      #georss gml representation
      #TODO
      def georss_gml_representation(options) #:nodoc:
        georss_ns = options[:georss_ns] || "georss"
        gml_ns = options[:gml_ns] || "gml"

        result = "<#{georss_ns}:where>\n<#{gml_ns}:LineString>\n<#{gml_ns}:posList>\n"
        result += georss_poslist
        result += "\n</#{gml_ns}:posList>\n</#{gml_ns}:LineString>\n</#{georss_ns}:where>\n"
      end

      #TODO
      def georss_poslist #:nodoc:
        map {|point| "#{point.y} #{point.x}"}.join(" ")
      end

      #outputs the geometry in kml format : options are <tt>:id</tt>, <tt>:tesselate</tt>, <tt>:extrude</tt>,
      #<tt>:altitude_mode</tt>. If the altitude_mode option is not present, the Z (if present) will not be output (since
      #it won't be used by GE anyway: clampToGround is the default)
      #TODO
      def kml_representation(options = {}) #:nodoc:
        result = "<LineString#{options[:id_attr]}>\n"
        result += options[:geom_data] if options[:geom_data]
        result += "<coordinates>"
        result += kml_poslist(options)
        result += "</coordinates>\n"
        result += "</LineString>\n"
      end

      #TODO
      def kml_poslist(options) #:nodoc:
        pos_list = if options[:allow_z]
           map {|point| "#{point.x},#{point.y},#{options[:fixed_z] || point.z || 0}" }
        else
          map {|point| "#{point.x},#{point.y}" }
        end
        pos_list.reverse! if(options[:reverse])
        pos_list.join(" ")
      end

      # simple geojson representation
      # TODO add CRS / SRID support?
      #TODO
      def to_json(options = {})
        {:type => 'LineString',
         :coordinates => self.to_coordinates}.to_json(options)
      end
      alias :as_geojson :to_json

      #Creates a new circular string. Accept an array of points as argument
      def self.from_points(points,srid=DEFAULT_SRID,with_z=false,with_m=false)
        circular_string = new(srid,with_z,with_m)
        circular_string.concat(points)
        circular_string
      end

      #Creates a new circular string. Accept a sequence of points as argument : ((x,y)...(x,y))
      def self.from_coordinates(points,srid=DEFAULT_SRID,with_z=false,with_m=false)
        circular_string = new(srid,with_z,with_m)
        circular_string.concat( points.map {|p| Point.from_coordinates(p,srid,with_z,with_m) } )
        circular_string
      end
    end
  end
end
