

### Linq group by 多个字段
```sql
var groups = (from p in resultList
group p by new { p.SendNo, p.CarrierNo }
into g
select new { g.Key.SendNo, g.Key.CarrierNo, list = g }).ToList();
```