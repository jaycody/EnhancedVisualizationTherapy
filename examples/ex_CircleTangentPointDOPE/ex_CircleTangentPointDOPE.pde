/**
 * <p>This simple example shows how to compute tangent points on a circle using
 * the new Circle and Line2D classes. Furthermore, the demo shows how these points
 * are constructed geometrically and how to use the ToxiclibsSupport class of
 * the toxi.processing package to handle the drawing of these geometrical shapes.</p>
 *
 * <p><strong>Usage:</strong><ul>
 * <li>move mouse to move/recalculate tangents</li>
 * <li>click+drag mouse to adjust circle radius</li>
 * </ul></p>
 */

/* 
 * Copyright (c) 2010 Karsten Schmidt
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * http://creativecommons.org/licenses/LGPL/2.1/
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */

import toxi.geom.*;
import toxi.processing.*;

// define a fixed circle at 300,300 with radius=100
Circle c=new Circle(350, 350, 100);
Circle c2=new Circle(600, 350, 100);

ToxiclibsSupport gfx;

void setup() {
  size(1024, 768);
  noFill();
  gfx=new ToxiclibsSupport(this);
}

void draw() {
  background(0);
  stroke(255);
  strokeWeight(2);
  Vec2D p=new Vec2D(mouseX, mouseY);
  Vec2D p2=new Vec2D(width-mouseX, height-mouseY);
  // adjust the main circle radius on mouse press
  if (mousePressed) {
    c.setRadius(p.distanceTo(c));
    c2.setRadius(p2.distanceTo(c2));
  }
  Line2D l=new Line2D(p, c);
  gfx.ellipse(c);
  gfx.line(p, c);
  // compute the tangent points to P on the circle
  Vec2D[] isec=c.getTangentPoints(p);
  if (isec!=null) {
    for (int i=0; i<2; i++) {
      gfx.ellipse(new Circle(isec[i], 5));
      gfx.ray(new Ray2D(p, isec[i].sub(p)), 1000);
      gfx.line(c, isec[i]);
    }
    // draw secondary circle around mid-point
    // from main circle to mouse position
    gfx.ellipse(new Circle(l.getMidPoint(), l.getLength()/2));
  }

  Line2D l2=new Line2D(p2, c2);
  gfx.ellipse(c2);
  gfx.line(p2, c2);
  // compute the tangent points to P on the circle
  Vec2D[] isec2=c2.getTangentPoints(p2);
  if (isec2!=null) {
    for (int i=0; i<2; i++) {
      gfx.ellipse(new Circle(isec2[i], 5));
      gfx.ray(new Ray2D(p2, isec2[i].sub(p2)), 1000);
      gfx.line(c2, isec2[i]);
    }
    // draw secondary circle around mid-point
    // from main circle to mouse position
    gfx.ellipse(new Circle(l2.getMidPoint(), l2.getLength()/2));
  }
}

