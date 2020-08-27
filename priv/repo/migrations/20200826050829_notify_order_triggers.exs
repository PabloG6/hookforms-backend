defmodule Haberdash.Repo.Migrations.NotifyOrderTriggers do
  use Ecto.Migration

  def change do
    execute("CREATE or REPLACE FUNCTION notify_order_changes()
              RETURNS trigger AS $trigger$
              DECLARE
                current_row RECORD;
              BEGIN
                IF(TG_OP = 'INSERT' or TG_OP='UPDATE') THEN
                  current_row := NEW;
                ELSE
                  current_row := OLD;
                END IF;
                PERFORM pg_notify('order_changes',
                  json_build_object(
                    'table', TG_TABLE_NAME,
                    'type', TG_OP,
                    'id', current_row.id,
                    'data', row_to_json(current_row)
                  )::text
                  );
                  RETURN current_row;
              END
              $trigger$ LANGUAGE plpgsql;
              ")

  execute("CREATE TRIGGER order_changes_trg
          AFTER INSERT OR UPDATE OR DELETE ON orders FOR EACH ROW
          EXECUTE PROCEDURE notify_order_changes()")

  end
end
