defmodule Haberdash.Repo.Migrations.NotifyFranchiseTriggers do
  use Ecto.Migration

  def up do
    execute("CREATE OR REPLACE FUNCTION notify_franchise_init_triggers()
              RETURNS TRIGGER as $franchise_trigger$
            DECLARE
              current_row RECORD;

            BEGIN
              IF(TG_OP = 'INSERT' or TG_OP='UPDATE') THEN
                current_row := NEW;
              ELSIF (TG_OP = 'DELETE') THEN
                current_row := OLD;

              ELSE
                current_row := OLD;
              END IF;
              PERFORM pg_notify('franchise_created', json_build_object(
                'table', TG_TABLE_NAME,
                'type', TG_OP,
                'id', current_row.id,
                'data', row_to_json(current_row)
                )::text
                );
              RETURN current_row;
            END
            $franchise_trigger$ LANGUAGE plpgsql;")

    execute("CREATE TRIGGER franchise_create_trg
            AFTER INSERT OR UPDATE OR DELETE ON franchise FOR EACH ROW
            EXECUTE PROCEDURE notify_franchise_init_triggers()")
  end

  def down do
    execute "DROP TRIGGER IF EXISTS franchise_create_trg on franchise"
    execute "DROP FUNCTION IF EXISTS notify_franchise_init_triggers CASCADE"
  end
end
