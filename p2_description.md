
1.  Deployment
    https://kubernetes.io/docs/concepts/workloads/controllers/deployment/

    readinessProbe и livenessProbe
    Жизнеспособность и готовность контейнера.
    Если проверка на рабочее состояние приложения внутри контейнера завалена, то контейнер будет перезапущен.
    https://kubernetes.io/ru/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/

    minReadySeconds
    https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#min-ready-seconds

    Просто хороший тон. Оставить метку ответственного за это развертывание.
    annotations:
        IOT/owner: "m&m's"

    securityContext:
        readOnlyRootFilesystem
    Настройка не позволит контейнеру в его собственной файловой системе делать записи и как следствие не позволит воспользоваться уязвимостями в Docker и Kubernetes
    https://kubernetes.io/docs/tasks/configure-pod-container/security-context/

    Объект StatefulSet
    для поседовательного запуска pod-оболочек(например, сначала pod с базой данных, потом с Wordpress и т.д.)
    https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/
    https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/

с.197
    Для максимальной безопасности следует убрать любые мандаты для контейнеров
и затем по мере необходимости отдельно их выдавать:
containers:
- name: demo
image: cloudnatived/demo:hello
securityContext:
capabilities:
drop: ["all"]
add: ["NET_BIND_SERVICE"]

2.  configmap. Настройка конфигов.
    https://kubernetes.io/docs/concepts/configuration/configmap/

    configmap "позволяет использовать Go templates в конфигах, т.е. рендерить их подобно HTML-страницам и делать reload приложения при изменении конфига без рестарта"
    При изменении данных в одном из указанных в configmap конфиге, под сам перезапустится (есть исключение)
    https://habr.com/ru/company/flant/blog/498970/