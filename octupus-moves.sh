: '
Move Octupus to airflow pod
'
#!/bin/sh


# Clean up
clean_up(){
    echo "Cleaning....."
    unset AIRFLOW_POD
}

#Removing rubbish upon exit
trap clean_up EXIT
AIRFLOW_POD=$(kubectl get pods | awk '{print $1}' | grep  "airflow*")
kubectl cp ./octupus-master.sh $AIRFLOW_POD:/airflow/dags/ -c airflow-scheduler
kubectl exec $AIRFLOW_POD -c airflow-scheduler -- bash -c "cd /airflow/dags && mv octupus-master.sh octupus.sh && chmod +x octupus.sh"
kubectl exec $AIRFLOW_POD -c airflow-scheduler -- bash -c "cd /airflow/dags && ./octupus.sh "
exit 0

