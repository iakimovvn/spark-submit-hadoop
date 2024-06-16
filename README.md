Для запуска задачи s spark-submit необходимо:
* Собрать свой spark-submit jar c зависимостями и полдожить его в контейнер:
```
spark-submit:/opt/yvn
```
* Собрать проект:
  ```
  mvn clean install
  ```
* Перейти в директорию ```target/docker``` и запустить сборку контейнеров с использованием launch.sh.
  ```shell
  cd target/docker && chmod +x launch.sh &&  ./launch.sh
  ```
* Перейти в ```spark-submit``` контейнер в директорию  ```/opt/yvn```
  ```shell
  docker exec -it spark-submit bash
  ```
  ```shell
  cd /opt/aspk
  ```
* Для корректного подключения spark к hive-metastore, необходимо включить ```enableHiveSupport``` при инициализации spark
```java
public class SparkService {
    public SparkSession getSession() {
        return SparkSession.builder().enableHiveSupport().getOrCreate();
    }
}
```
* Запуск задач в кластерном режиме мз контейнера spark-submit
