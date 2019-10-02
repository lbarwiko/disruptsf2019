import { Router } from 'express';

export default(redis, config)=>{
    const router = Router();

    router.get('/', (req, res) => {
		res.send({
			version: '1.0',
			url: req.url
		})
    });

    return router;

}