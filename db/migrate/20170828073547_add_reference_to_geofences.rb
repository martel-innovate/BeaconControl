class AddReferenceToGeofences < ActiveRecord::Migration
  def change
    add_reference :geofences, :application
    add_reference :geofences, :customer

    add_reference :schedules, :application
    add_reference :schedules, :customer

    add_reference :bus_stops, :application
    add_reference :bus_stops, :customer

    add_reference :toilets, :application
    add_reference :toilets, :customer

    add_reference :notifications, :customer

    add_reference :places, :application
    add_reference :places, :customer

    add_reference :advertisments, :application
    add_reference :advertisments, :customer

    add_reference :home_sliders, :application
    add_reference :home_sliders, :customer
  end
end
