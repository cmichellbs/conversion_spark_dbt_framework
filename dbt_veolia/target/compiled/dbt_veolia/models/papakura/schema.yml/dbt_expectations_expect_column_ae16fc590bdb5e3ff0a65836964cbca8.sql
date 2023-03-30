




with validation_errors as (

    select
        nr_fatura
    from "papakura_20221223"."dbo_mig"."fat_fatura"
    where
        1=1
        and 
    not (
        nr_fatura is null
        
    )


    
    group by
        nr_fatura
    having count(*) > 1

)
select * from validation_errors

