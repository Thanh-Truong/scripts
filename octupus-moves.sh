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
AIRFLOW_POD=airflow-deployment-75858d497c-5sl4w
kubectl cp ./octupus-merge.sh $AIRFLOW_POD:/airflow/dags/ -c airflow-scheduler
kubectl exec $AIRFLOW_POD -c airflow-scheduler -- bash -c "cd /airflow/dags && mv octupus-merge.sh octupus.sh && chmod +x octupus.sh"

exit 0

