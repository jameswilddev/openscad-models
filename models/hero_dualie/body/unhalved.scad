include <../../settings.scad>;
use <../../utilities/math.scad>;
use <../../utilities/cylinders.scad>;
include <measurements.scad>;
use <outer.scad>;
use <indent.scad>;
use <cutout.scad>;
include <../barrel/measurements.scad>;
include <../fore/measurements.scad>;
include <../safety/measurements.scad>;
use <../../connectors/notched_circle/male.scad>;
use <../../connectors/notched_circle/female.scad>;
use <../trigger/shape.scad>;

module hero_dualie_body_unhalved() {
  difference() {
    union() {
      difference() {
        // Tail cutout.
        linear_extrude(hero_dualie_body_thickness, center = true) {
          difference() {
            hero_dualie_body_outer();
            hero_dualie_body_cutout();
          };
        }

        // Right indent.
        translate([
          0,
          0,
          hero_dualie_body_thickness / 2 - hero_dualie_body_indent_depth
        ]) {
          linear_extrude(hero_dualie_body_indent_depth) {
            hero_dualie_body_indent();
          };
        };

        // Left indent.
        translate([
          0,
          0,
          hero_dualie_body_thickness / -2
        ]) {
          linear_extrude(hero_dualie_body_indent_depth) {
            hero_dualie_body_indent();
          };
        };

        translate([
          hero_dualie_barrel_connector_length,
          hero_dualie_body_front_height / 2,
          -0.001
        ]) {
          // A hole for the barrel.
          rotate([0, -90, 0]) {
            cylinder(
              d = hero_dualie_barrel_diameter + loose_tolerance * 2,
              h = hero_dualie_barrel_connector_length + 0.001,
              $fn = cylinder_sides(hero_dualie_barrel_diameter)
            );
          };
        };

        translate([
          hero_dualie_barrel_connector_length,
          hero_dualie_body_front_height / 2,
          0
        ]) {
          // A hole for the barrel LED.
          rotate([0, 90, 0]) {
            cylinder(
              d = hero_dualie_barrel_led_hole_diameter,
              h = hero_dualie_barrel_connector_length + 10,
              $fn = cylinder_sides(5 + loose_tolerance)
            );
          };
        };

        rotate([0, 90, -90]) {
          translate([
            0,
            hero_dualie_fore_glow_pillar_x,
            hero_dualie_fore_glow_pillar_y - hero_dualie_body_front_height
          ]) {
            rotate([
              -hero_dualie_fore_glow_pillar_angle,
              0,
              0
            ]) {
              // The connector to the fore.
              connectors_notched_circle_female(hero_dualie_fore_glow_pillar_diameter, hero_dualie_fore_glow_pillar_connector_length, hero_dualie_fore_glow_pillar_connector_notches);

              // A hole for the fore LED.
              cylinder(
                d = hero_dualie_barrel_led_hole_diameter,
                h = hero_dualie_fore_glow_pillar_connector_length + 30,
                $fn = cylinder_sides(5 + loose_tolerance)
              );
            };
          };
        };

        // The connector for the safety.
        translate([
          hero_dualie_body_safety_x,
          hero_dualie_body_safety_y,
          hero_dualie_body_thickness / -2
        ]) {
          rotate([0, 0, hero_dualie_body_safety_angle]) {
            connectors_notched_circle_female(
              hero_dualie_safety_connector_diameter,
              hero_dualie_safety_connector_length,
              hero_dualie_safety_connector_notches
            );
          };
        }
      };

      // The connector to the barrel.
      translate([
        hero_dualie_barrel_connector_length,
        hero_dualie_body_front_height / 2,
        0
      ]) {
        rotate([0, -90, 0]) {
          connectors_notched_circle_male(
            hero_dualie_barrel_connector_diameter,
            hero_dualie_barrel_connector_length,
            hero_dualie_barrel_connector_notches
          );
        };
      };

      // The cap on the handle.
      intersection() {
        translate([
          hero_dualie_body_handle_x,
          hero_dualie_body_handle_y,
          0
        ]) {
          rotate([-90, 0, 0]) {
            cylinder(
              d = hero_dualie_body_handle_cap_diameter,
              h = hero_dualie_body_handle_cap_height,
              $fn = cylinder_sides(hero_dualie_body_handle_cap_diameter)
            );
          };
        };

        translate([
          hero_dualie_body_handle_x - hero_dualie_body_handle_length / 2,
          hero_dualie_body_handle_y,
          hero_dualie_body_handle_cap_diameter / -2
        ]) {
          cube([
            hero_dualie_body_handle_length,
            hero_dualie_body_handle_cap_height,
            hero_dualie_body_handle_cap_diameter
          ]);
        };
      };

      // The "blobs" above the handle.
      intersection() {
        translate([
          hero_dualie_body_handle_x - hero_dualie_body_handle_merger_width / 2,
          hero_dualie_body_handle_y - hero_dualie_body_handle_merger_height,
          -hero_dualie_body_handle_merger_z
        ]) {
          cube([
            hero_dualie_body_handle_merger_width,
            hero_dualie_body_handle_merger_height,
            hero_dualie_body_handle_merger_z * 2
          ]);
        };
        hull() {
          translate([
            hero_dualie_body_handle_x,
            hero_dualie_body_handle_y,
            hero_dualie_body_handle_merger_z - hero_dualie_body_handle_merger_thickness
          ]) {
            scale([
              hero_dualie_body_handle_merger_width / 2,
              hero_dualie_body_handle_merger_height,
              hero_dualie_body_handle_merger_thickness
            ]) {
              sphere(
                1,
                $fn = cylinder_sides(hero_dualie_body_handle_merger_height * 2)
              );
            };
          };
          translate([
            hero_dualie_body_handle_x,
            hero_dualie_body_handle_y,
            hero_dualie_body_handle_merger_thickness - hero_dualie_body_handle_merger_z
          ]) {
            scale([
              hero_dualie_body_handle_merger_width / 2,
              hero_dualie_body_handle_merger_height,
              hero_dualie_body_handle_merger_thickness
            ]) {
              sphere(
                1,
                $fn = cylinder_sides(hero_dualie_body_handle_merger_height * 2)
              );
            };
          };
        };
      };

      // The connector to the handle.
      translate([
        hero_dualie_body_handle_x,
        hero_dualie_body_handle_y + hero_dualie_body_handle_cap_height,
        0
      ]) {
        rotate([-90, 90, 0]) {
          connectors_notched_circle_male(
            hero_dualie_body_handle_connector_diameter,
            hero_dualie_body_handle_connector_length,
            hero_dualie_body_handle_connector_notches
          );
        };
      };
    };

    // A hole for the trigger.
    translate([
      hero_dualie_body_safety_x,
      hero_dualie_body_safety_y,
      0
    ]) {
      rotate([0, 0, 90 + hero_dualie_body_trigger_angle]) {
        minkowski() {
          cylinder(
            d = tight_tolerance * 2,
            h = tight_tolerance * 2,
            $fn = cylinder_sides(tight_tolerance * 2),
            center = true
          );
          hero_dualie_trigger_shape();
        };
      };
    };

    // A hole for the handle wire.
    translate([
      hero_dualie_body_handle_x,
      hero_dualie_body_handle_y + hero_dualie_body_handle_cap_height,
      0
    ]) {
      rotate([90, 0, 0]) {
        cylinder(
          d = hero_dualie_barrel_led_hole_diameter,
          h = 50,
          $fn = cylinder_sides(5 + loose_tolerance)
        );
      };
    };

    // A cavity for cable slack.
    linear_extrude(hero_dualie_barrel_led_hole_diameter, center = true) {
      polygon([
        [20, 15],
        [100, 50],
        [100, 80],
        [10, 30]
      ]);
    };
  };

  // Supports in the cable slack cavity.
  for (progress = [0:0.1:1]) {
    translate(linear_interpolate(
      [25, 28],
      [90, 60],
      progress
    )) {
      cylinder(
        d = hero_dualie_body_slack_post_diameter,
        h = hero_dualie_barrel_led_hole_diameter,
        $fn = cylinder_sides(hero_dualie_body_slack_post_diameter),
        center = true
      );
      cube([
        hero_dualie_body_slack_post_diameter,
        hero_dualie_body_slack_beam_length,
        hero_dualie_body_slack_beam_thickness
      ], center = true);
    };
  };
};
