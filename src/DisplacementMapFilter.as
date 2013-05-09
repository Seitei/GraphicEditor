/**
 *	Copyright (c) 2012 Andy Saia
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy
 *	of this software and associated documentation files (the "Software"), to deal
 *	in the Software without restriction, including without limitation the rights
 *	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *	copies of the Software, and to permit persons to whom the Software is
 *	furnished to do so, subject to the following conditions:
 *
 *	The above copyright notice and this permission notice shall be included in
 *	all copies or substantial portions of the Software.
 *
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *	THE SOFTWARE.
 */

package
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	
	import starling.filters.FragmentFilter;
	import starling.textures.Texture;
	
	public class DisplacementMapFilter extends FragmentFilter
	{
		private var mShaderProgram:Program3D;
		private var mMapTexture:Texture;
		private var mScale:Number;
		
		public function DisplacementMapFilter(mapTexture:Texture = null, scale:Number = 0)
		{
			mMapTexture = mapTexture;
			mScale = scale;
		}
		
		public override function dispose():void
		{
			if (mShaderProgram) mShaderProgram.dispose();
			super.dispose();
		}
		
		protected override function createPrograms():void
		{
			var vertexShaderString:String =
				"m44 op, va0, vc0 \n" + // 4x4 matrix transform to output space
				"mov v0, va1     \n";  // pass texture coordinates to fragment program
			
			var fragmentShaderString:String =
				"tex ft1, v0, fs1 <2d, linear, nomip> \n" + // just forward texture color
				"add ft2, fc0, ft1 \n" + //add color to constant
				"mul ft2, ft2, fc0.z \n" + //scale our displacement direction by strength
				"add ft3, v0, ft2 \n" + //result direction we should add to original texture coordinates that came as varing parameter frm vertex shader
				"tex oc, ft3, fs0 <2d, linear,nomip> \n"; //outputs the resulting image
			
			mShaderProgram = assembleAgal(fragmentShaderString, vertexShaderString);
		}
		
		protected override function activate(pass:int, context:Context3D, texture:Texture):void
		{
			// already set by super class:
			//
			// vertex constants 0-3: mvpMatrix (3D)
			// vertex attribute 0:   vertex position (FLOAT_2)
			// vertex attribute 1:   texture coordinates (FLOAT_2)
			// texture 0:            input texture
			
			var scale:Vector.<Number> = Vector.<Number>([ -0.5, -0.5, mScale, 0]);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, scale, 1); //sets this vector to fc0
			
			context.setTextureAt(1, mMapTexture.base); //sets the texture to fs1
			context.setProgram(mShaderProgram);
		}
		
		override protected function deactivate(pass:int, context:Context3D, texture:Texture):void
		{
			context.setTextureAt(1, null); //be sure to null out the texture
		}
		
		//---------------
		//  getters and setters
		//---------------
		
		public function get mapTexture():Texture
		{
			return mMapTexture;
		}
		/**
		 * texture that will be used to calculate displacement
		 */
		public function set mapTexture(value:Texture):void
		{
			mMapTexture = value;
		}
		
		public function get scale():Number
		{
			return mScale;
		}
		
		/**
		 * the amount of displacement... values should be small 0 through 1
		 */
		public function set scale(value:Number):void
		{
			mScale = value;
		}
	}
}