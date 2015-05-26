class AddTriggers < ActiveRecord::Migration
  def self.up
    ###### companies ######
    execute(
      "CREATE OR REPLACE FUNCTION company_save_his()
        RETURNS trigger AS
      $BODY$BEGIN
      insert into company_histories (
        company_id,
        short,
        name, 
        address_city,
        address_street,
        address_house,
        address_number,
        address_postal_code,
        phone,
        email,
        nip,
        regon,
        pesel,
        informal_group,
        note,
        user_id,
        created_at,
        updated_at ) values (
          NEW.id,
          NEW.short,
          NEW.name, 
          NEW.address_city,
          NEW.address_street,
          NEW.address_house,
          NEW.address_number,
          NEW.address_postal_code,
          NEW.phone,
          NEW.email,
          NEW.nip,
          NEW.regon,
          NEW.pesel,
          NEW.informal_group,
          NEW.note,
          NEW.user_id,
          NEW.created_at,
          NEW.updated_at );
      RETURN NEW;
      END;$BODY$
        LANGUAGE plpgsql;")

    execute(
      "CREATE TRIGGER tr_company_save_his
        AFTER INSERT OR UPDATE
        ON companies
        FOR EACH ROW
        EXECUTE PROCEDURE company_save_his();")
    ###### ./companies ######



    ###### individuals ######
    execute(
      "CREATE OR REPLACE FUNCTION individual_save_his()
        RETURNS trigger AS
      $BODY$BEGIN
      insert into individual_histories (
        individual_id,
      	last_name,
      	first_name,
        address_city,
        address_street,
        address_house,
        address_number,
        address_postal_code,
      	pesel,
      	birth_date,
      	profession,
        note,
        user_id,
        created_at,
        updated_at ) values (
          NEW.id,
          NEW.last_name,
          NEW.first_name, 
          NEW.address_city,
          NEW.address_street,
          NEW.address_house,
          NEW.address_number,
          NEW.address_postal_code,
          NEW.pesel,
          NEW.birth_date,
          NEW.profession,
          NEW.note,
          NEW.user_id,
          NEW.created_at,
          NEW.updated_at );
      RETURN NEW;
      END;$BODY$
        LANGUAGE plpgsql;")

    execute(
      "CREATE TRIGGER tr_individual_save_his
        AFTER INSERT OR UPDATE
        ON individuals
        FOR EACH ROW
        EXECUTE PROCEDURE individual_save_his();")
    ###### ./individuals ######



    ###### insurances ######
    execute(
      "CREATE OR REPLACE FUNCTION insurance_save_his()
        RETURNS trigger AS
      $BODY$BEGIN
      insert into insurance_histories (
        insurance_id,
				number,
      	concluded,
      	valid_from,
      	applies_to,
      	pay,
      	insurance_lock,
        note,
        company_id,
        user_id,
        created_at,
        updated_at ) values (
          NEW.id,
				  NEW.number,
      	  NEW.concluded,
      	  NEW.valid_from,
      	  NEW.applies_to,
      	  NEW.pay,
      	  NEW.insurance_lock,
          NEW.note,
          NEW.company_id,
          NEW.user_id,
          NEW.created_at,
          NEW.updated_at );
      RETURN NEW;
      END;$BODY$
        LANGUAGE plpgsql;")

    execute(
      "CREATE TRIGGER tr_insurance_save_his
        AFTER INSERT OR UPDATE
        ON insurances
        FOR EACH ROW
        EXECUTE PROCEDURE insurance_save_his();")
    ###### ./insurances ######



    ###### rotations ######
    execute(
      "CREATE OR REPLACE FUNCTION rotation_save_his()
        RETURNS trigger AS
      $BODY$BEGIN
      insert into rotation_histories (
        rotation_id,
				rotation_date,
      	rotation_lock,
      	date_file_send,
        insurance_id,
        created_at,
        updated_at ) values (
          NEW.id,
				  NEW.rotation_date,
      	  NEW.rotation_lock,
      	  NEW.date_file_send,
          NEW.insurance_id,
          NEW.created_at,
          NEW.updated_at );
      RETURN NEW;
      END;$BODY$
        LANGUAGE plpgsql;")

    execute(
      "CREATE TRIGGER tr_rotation_save_his
        AFTER INSERT OR UPDATE
        ON rotations
        FOR EACH ROW
        EXECUTE PROCEDURE rotation_save_his();")
    ###### ./rotations ######
  end

  def self.down
    ###### companies ######
  	execute("DROP TRIGGER IF EXISTS tr_company_save_his ON companies;")
  	execute("DROP FUNCTION IF EXISTS company_save_his() CASCADE;")
    ###### ./companies ######

    ###### individuals ######
  	execute("DROP TRIGGER IF EXISTS tr_individual_save_his ON individuals;")
  	execute("DROP FUNCTION IF EXISTS individual_save_his() CASCADE;")
    ###### ./individuals ######

    ###### insurances ######
  	execute("DROP TRIGGER IF EXISTS tr_insurance_save_his ON insurances;")
  	execute("DROP FUNCTION IF EXISTS insurance_save_his() CASCADE;")
    ###### ./insurances ######

    ###### rotations ######
  	execute("DROP TRIGGER IF EXISTS tr_rotation_save_his ON rotations;")
  	execute("DROP FUNCTION IF EXISTS rotation_save_his() CASCADE;")
    ###### ./rotations ######
  end

end
