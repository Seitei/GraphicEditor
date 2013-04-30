package utils
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class ResourceManager
	{
		private static var _instance:ResourceManager;
		
		[Embed(source = "../assets/arrow.png")]
		private static const Arrow:Class;
		
		[Embed(source = "../assets/car_1.jpg")]
		private static const Car1:Class;
		
		[Embed(source = "../assets/car_2.png")]
		private static const Car2:Class;
		
		[Embed(source = "../assets/car_3.png")]
		private static const Car3:Class;
		
		[Embed(source = "../assets/toy_1.jpg")]
		private static const Toy1:Class;
		
		[Embed(source = "../assets/toy_2.jpg")]
		private static const Toy2:Class;
		
		[Embed(source = "../assets/toy_3.jpg")]
		private static const Toy3:Class;
		
		[Embed(source = "../assets/move_cursor.png")]
		private static const MoveCursor:Class;
		
		[Embed(source = "../assets/image_preview_container.png")]
		private static const ImagePreviewContainer:Class;
		
		/*[Embed(source = "../assets/balanced_square_btn.png")]
		private static const BalancedSquareBtn:Class;
		[Embed(source="../assets/balanced_square_btn.xml", mimeType="application/octet-stream")]
		public static const BalancedSquareBtnXML:Class;*/
		
		
		
		////////////
		
		private var TextureAssets:Dictionary = new Dictionary();
		private var XMLAssets:Dictionary = new Dictionary();
		private var _textures:Dictionary = new Dictionary();
		private var _xmls:Dictionary = new Dictionary();
		
		public function ResourceManager()
		{
			TextureAssets["arrow"] = Arrow;
			TextureAssets["car_1"] = Car1;
			TextureAssets["car_2"] = Car2;
			TextureAssets["car_3"] = Car3;
			TextureAssets["toy_1"] = Toy1;
			TextureAssets["toy_2"] = Toy2;
			TextureAssets["toy_3"] = Toy3;
			TextureAssets["move_cursor"] = MoveCursor;
			TextureAssets["image_preview_container"] = ImagePreviewContainer;
				
			/*TextureAssets["square_btn"] = SquareBtn;
			XMLAssets["square_btn"] = SquareBtnXML;*/
		
			
			
		}
		
		public function getTextures(name:String, prefix:String = "", animate:Boolean = true):Vector.<Texture> {
			
			if (TextureAssets[name] != undefined)
			{
				if (_textures[name + "." + prefix] == undefined)
				{
					var bitmap:Bitmap = new TextureAssets[name];
					var texture:Texture = _textures[name] = Texture.fromBitmap(bitmap);
					var frames:Vector.<Texture> = new Vector.<Texture>();
					
					
					var xml:XML = XML(new XMLAssets[name]);
					var textureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
					frames = textureAtlas.getTextures(prefix);
					_textures[name + "." + prefix] = frames;
					
				}
			}
			else
				throw new Error("Resource not defined!");
			
			return _textures[name + "." + prefix];
		}
		
		public function getTexture(name:String, prefix:String = ""):Texture
		{
			if (TextureAssets[name] != undefined)
			{
				if(prefix == ""){
					if (_textures[name] == undefined)
					{
						var bitmap:Bitmap = new TextureAssets[name]();
						_textures[name] = Texture.fromBitmap(bitmap);
					}
					return _textures[name];
				} 
				else {
					if (_textures[name + "." + prefix] == undefined)
					{
						var bitmap2:Bitmap = new TextureAssets[name];
						var texture:Texture = _textures[name] = Texture.fromBitmap(bitmap2);
						var frames:Vector.<Texture> = new Vector.<Texture>();
						
						var xml:XML = XML(new XMLAssets[name]);
						var textureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
						frames = textureAtlas.getTextures(prefix);
						_textures[name + "." + prefix] = frames[0];
					}
					return _textures[name + "." + prefix];
				}
				
				return _textures[name];
			} 
			else throw new Error("Resource not defined.");
		}
		
		public static function getInstance():ResourceManager {
			if (!_instance)
				_instance = new ResourceManager();
			return _instance
		}
	}
	
	
	
	
	
	
	
	
	
	
}