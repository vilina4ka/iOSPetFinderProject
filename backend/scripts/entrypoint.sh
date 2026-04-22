set -e

echo "Ожидание готовности PostgreSQL..."

until psql "$DATABASE_URL" -c '\q' 2>/dev/null; do
  echo "   PostgreSQL не готова, ждём..."
  sleep 2
done

echo "PostgreSQL готова"
echo "Применение миграций..."

for f in /app/migrations/*.sql; do
  echo "   → $(basename "$f")"
  psql "$DATABASE_URL" -f "$f"
done

echo "Миграции применены"
echo "Запуск сервера..."
exec ./lapki
